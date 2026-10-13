<#macro registrationLayout displayMessage=true displayInfo=false displayRequiredFields=false section=""
    displayWide=false showAnotherWayIfPresent=true>
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="robots" content="noindex, nofollow">
        <#if properties.meta?has_content>
            <#list properties.meta?split(' ') as meta>
                <meta name="${meta?split('==')[0]}" content="${meta?split('==')[1]}">
            </#list>
        </#if>
        <title>${msg("loginTitle", (realm.displayName!''))}</title>
        <#if properties.styles?has_content>
            <#list properties.styles?split(' ') as style>
                <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
            </#list>
        </#if>
        <#if properties.scripts?has_content>
            <#list properties.scripts?split(' ') as script>
                <script src="${url.resourcesPath}/${script}" type="text/javascript"></script>
            </#list>
        </#if>
    </head>
    <body>
        <div class="login-container">
            <header>
                <#nested "header">
            </header>
            
            <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
                <div class="alert-${message.type}">
                    ${message.summary}
                </div>
            </#if>

            <main>
                <#nested "form">
            </main>

            <#nested "socialProviders">
            
            <#if displayInfo>
                <#nested "info">
            </#if>
        </div>
    </body>
    </html>
</#macro>
