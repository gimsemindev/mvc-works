package com.mvc.app.service;

import java.util.List;
import java.util.Random;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.document.Document;
import org.springframework.ai.vectorstore.SearchRequest;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import reactor.core.publisher.Flux;

@Service
public class QnaBotService {

    private final ChatClient chatClient;
    private final VectorStore vectorStore;
    private final Random random = new Random();

    public QnaBotService(ChatClient.Builder chatClientBuilder,
                         @Qualifier("pgVectorStore") VectorStore vectorStore) {
        this.chatClient = chatClientBuilder.build();
        this.vectorStore = vectorStore;
    }

    public Flux<String> generateAnswer(String question) {
        try {
            // 메뉴/식사 관련 질문 처리
            if (question.contains("메뉴") || question.contains("식사") 
                    || question.contains("점심") || question.contains("저녁")) {

                String[] koreanMenus = {
                        "김치찌개", "된장찌개", "순두부찌개", "제육볶음", "불고기",
                        "비빔밥", "냉면", "칼국수", "김밥", "떡볶이",
                        "삼겹살", "갈비찜", "오징어볶음", "두부조림", "잡채",
                        "닭볶음탕", "갈비탕", "콩나물국밥", "순대국", "육개장",
                        "해물파전", "김치전", "보쌈", "족발", "오리불고기",
                        "김치볶음밥", "제육덮밥", "돌솥비빔밥", "콩비지찌개", "청국장"
                };

                String[] chineseMenus = {
                        "짜장면", "짬뽕", "볶음밥", "탕수육", "마파두부",
                        "깐풍기", "유린기", "양장피", "팔보채", "고추잡채",
                        "라조기", "군만두", "딤섬", "마라탕", "마라샹궈",
                        "훠궈", "삼선짬뽕", "쟁반짜장", "볶음국수", "중국식닭튀김",
                        "양송이덮밥", "굴소스소고기", "계란볶음밥", "꽃빵", "중국식죽",
                        "꿔바로우", "사천식닭찜", "중국식해물볶음", "두반장두부", "중국식면류"
                };

                String[] japaneseMenus = {
                        "초밥", "돈카츠", "규동", "우동", "라멘",
                        "카레라이스", "오므라이스", "텐동", "사케동", "가라아게",
                        "스키야키", "샤부샤부", "오코노미야키", "야키토리", "소바",
                        "니기리즈시", "마키즈시", "카이센동", "타코야키", "라멘세트",
                        "일식샐러드", "교자", "미소된장국", "일본식커리우동", "오니기리",
                        "참치덮밥", "연어덮밥", "장어덮밥", "스시롤", "일본식카레"
                };

                String[] westernMenus = {
                        "파니니", "샌드위치", "클럽샌드위치", "핫도그", "오믈렛",
                        "프렌치토스트", "라자냐", "치킨파마산", "미트볼", "그라탕",
                        "스테이크", "햄버거", "피자", "리조또", "카프레제샐러드",
                        "파스타", "토마토스파게티", "봉골레파스타", "볼로네제파스타", "까르보나라",
                        "퀘사디아", "치즈버거", "리코타치즈샐러드", "프라이드치킨", "시저샐러드",
                        "베이컨치즈버거", "감바스", "크림파스타", "페스토파스타", "토마토리조또"
                };

                // 랜덤 선택
                String pickKorean = koreanMenus[random.nextInt(koreanMenus.length)];
                String pickChinese = chineseMenus[random.nextInt(chineseMenus.length)];
                String pickJapanese = japaneseMenus[random.nextInt(japaneseMenus.length)];
                String pickWestern = westernMenus[random.nextInt(westernMenus.length)];

                String answer = String.format(
                        "🍽️ 오늘의 점심 메뉴 추천 🍽️ \n\n 한식: %s\n중식: %s\n일식: %s\n양식: %s",
                        pickKorean, pickChinese, pickJapanese, pickWestern
                );

                return Flux.just(answer);
            }

            // 벡터 검색 기반 일반 QnA
            List<Document> results = vectorStore.similaritySearch(
                    SearchRequest.builder()
                            .query(question)
                            .similarityThreshold(0.3)
                            .topK(3)
                            .build()
            );

            String template = """
                    당신은 ERP 시스템 채팅봇입니다. 아래 컨텍스트를 바탕으로 직원의 질문에 정중하게 답변해 주십시오.
                    컨텍스트에 관련 정보가 있다면 반드시 그 내용을 바탕으로 답변하세요.
                    정보가 없을 때만 '해당 사항은 인사팀에 문의 바랍니다.'라고 답변하세요.
                    답변할 때 한 문장 끝날 때마다 줄바꿈을 하세요.
                    컨텍스트:
                    {context}
                    질문:
                    {question}
                    답변:
                    """;

            return chatClient.prompt()
                    .user(promptUserSpec -> promptUserSpec.text(template)
                            .param("context", results.toString())
                            .param("question", question))
                    .stream()
                    .content();

        } catch (Exception e) {
            return Flux.error(e);
        }
    }
}