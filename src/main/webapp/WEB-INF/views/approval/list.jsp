<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MVC</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<jsp:include page="/WEB-INF/views/layout/sidebarResources.jsp"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/approvallist.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/paginate.css" type="text/css">
<meta name="ctx" content="${pageContext.request.contextPath}">
<style>[v-cloak] { display: none; }</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
<jsp:include page="/WEB-INF/views/layout/sidebar.jsp"/>

<main id="main-content">
    <div id="vue-app" v-cloak>

        <jsp:include page="/WEB-INF/views/approval/include/approvalListTopbar.jsp"/>

        <div class="approval-body">
            <jsp:include page="/WEB-INF/views/approval/include/approvalListFilter.jsp"/>
            <jsp:include page="/WEB-INF/views/approval/include/approvalListTable.jsp"/>
        </div>

    </div>
</main>

<jsp:include page="/WEB-INF/views/vue/vue_cdn.jsp"/>

<script type="importmap">
{
    "imports": {
        "http": "/dist/util/http.js?v=2",
        "approvalListStore": "/dist/util/store/approvalListStore.js?v=1"
    }
}
</script>

<script type="module">
    import { createApp, onMounted } from 'vue';
    import { createPinia } from 'pinia';
    import { useApprovalListStore } from 'approvalListStore';

    const app = createApp({
        setup() {
            const store = useApprovalListStore();
            const ctx = document.querySelector('meta[name="ctx"]').content;

            const goCreate = () => { location.href = ctx + '/approval/create'; };

            onMounted(() => {
                store.fetchList();
            });

            return { store, ctx, goCreate };
        }
    });

    app.use(createPinia());
    app.mount('#vue-app');
</script>

</body>
</html>