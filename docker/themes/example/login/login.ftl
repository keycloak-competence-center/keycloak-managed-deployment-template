<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password') displayInfo=realm.password && realm.registrationAllowed && !registrationDisabled??; section>
    <#if section = "header">
        ${msg("loginAccountTitle")}
    <#elseif section = "form">
        <div id="kc-form">
            <div id="kc-form-wrapper">
                <#if realm.password>
                    <form id="kc-form-login" onsubmit="login.disabled = true; return true;" action="${url.loginAction}" method="post">
                        <div class="form-group">
                            <label for="username" class="sr-only">${msg("username")}</label>
                            <#if usernameEditDisabled??>
                                <input tabindex="1" id="username" class="form-control" name="username" value="${(login.username!'')}" type="text" disabled placeholder="${msg("username")}" />
                            <#else>
                                <input tabindex="1" id="username" class="form-control" name="username" value="${(login.username!'')}" type="text" autofocus autocomplete="username" placeholder="${msg("username")}" />
                            </#if>
                        </div>

                        <div class="form-group">
                            <label for="password" class="sr-only">${msg("password")}</label>
                            <input tabindex="2" id="password" class="form-control" name="password" type="password" autocomplete="current-password" placeholder="${msg("password")}" />
                        </div>

                        <div class="form-group login-options">
                            <#if realm.rememberMe && !usernameEditDisabled??>
                                <div class="checkbox">
                                    <label>
                                        <#if login.rememberMe??>
                                            <input tabindex="3" id="rememberMe" name="rememberMe" type="checkbox" checked> ${msg("rememberMe")}
                                        <#else>
                                            <input tabindex="3" id="rememberMe" name="rememberMe" type="checkbox"> ${msg("rememberMe")}
                                        </#if>
                                    </label>
                                </div>
                            </#if>
                        </div>

                        <div id="kc-form-buttons" class="form-group">
                            <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth?? && auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
                            <input tabindex="4" class="btn btn-primary btn-block" name="login" id="kc-login" type="submit" value="${msg("doLogIn")}"/>
                        </div>
                    </form>
                </#if>
            </div>
        </div>
    <#elseif section = "info" >
        <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
            <div id="kc-registration-container">
                <div id="kc-registration">
                    <span>${msg("noAccount")} <a tabindex="6" href="${url.registrationUrl}">${msg("doRegister")}</a></span>
                </div>
            </div>
        </#if>
    <#elseif section = "socialProviders" >
        <#if realm.password && social?? && social.providers??>
            <div id="kc-social-providers" class="social-providers">
                <hr>
                <p>${msg("or")}</p>
                <ul>
                    <#list social.providers as p>
                        <li><a href="${p.loginUrl}" class="btn btn-default">${msg("loginWith")} ${p.displayName}</a></li>
                    </#list>
                </ul>
            </div>
        </#if>
    </#if>
</@layout.registrationLayout>

<style>
/* Minimalistic CSS for Keycloak Login */
body {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    margin: 0;
    padding: 0;
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
}

#kc-form-wrapper {
    background: white;
    padding: 2rem;
    border-radius: 8px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    width: 100%;
    max-width: 400px;
}

.form-group {
    margin-bottom: 1rem;
}

.form-control {
    width: 100%;
    padding: 12px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 14px;
    box-sizing: border-box;
}

.form-control:focus {
    outline: none;
    border-color: #667eea;
    box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.2);
}

.btn-primary {
    background: #667eea;
    border: none;
    color: white;
    padding: 12px;
    border-radius: 4px;
    cursor: pointer;
    font-size: 14px;
    width: 100%;
}

.btn-primary:hover {
    background: #5a67d8;
}

.btn-default {
    background: #f7fafc;
    border: 1px solid #e2e8f0;
    color: #4a5568;
    padding: 8px 16px;
    border-radius: 4px;
    text-decoration: none;
    display: inline-block;
}

.btn-default:hover {
    background: #edf2f7;
}

.social-providers {
    text-align: center;
    margin-top: 1rem;
}

.social-providers ul {
    list-style: none;
    padding: 0;
    margin: 0;
}

.social-providers li {
    margin: 0.5rem 0;
}

hr {
    border: 0;
    border-top: 1px solid #e2e8f0;
    margin: 1rem 0;
}

.sr-only {
    position: absolute;
    width: 1px;
    height: 1px;
    padding: 0;
    margin: -1px;
    overflow: hidden;
    clip: rect(0, 0, 0, 0);
    white-space: nowrap;
    border: 0;
}

.checkbox {
    display: flex;
    align-items: center;
}

.checkbox input[type="checkbox"] {
    margin-right: 8px;
}

#kc-registration-container {
    text-align: center;
    margin-top: 1rem;
}

#kc-registration a {
    color: #667eea;
    text-decoration: none;
}

#kc-registration a:hover {
    text-decoration: underline;
}
</style>
