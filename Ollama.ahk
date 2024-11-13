class API_Wrapper {

    request(method, url, headers := "", body := "") {
        if (headers == "") {
            headers := {}
        }
        if !headers.HasKey("Content-Type") {
            headers["Content-Type"] := "application/json"
        }
        try {
            this.httpObj.Open(method, url)
            for key, value in headers {
                this.httpObj.SetRequestHeader(key, value)
            }
            this.httpObj.Send(body)
            this.httpObj.WaitForResponse()
            statusCode := this.httpObj.Status
            if (statusCode >= 200 && statusCode < 300) {
                return this.httpObj.ResponseText
            } else {
                MsgBox, 16, API Error, Request to %url% failed with status code %statusCode%.
                return
            }
        } catch {
            MsgBox, 16, API Error, Exception occurred.
            return
        }
    }

    postJson(endpoint, request, headers := "") {
        body := JSON.Dump(request)
        responseText := this.request("POST", this.host endpoint, headers, body)
        return JSON.Load(responseText)
    }

    getJson(endpoint) {
        responseText := this.request("GET", this.host endpoint)
        return JSON.Load(responseText)
    }

    requiredParams(object, params) {
        for key, value in params {
            if (!object.HasKey(value)) {
                MsgBox, 16, Missing Parameter, The parameter %value% is missing.
                return false
            }
        }
    }
}

class Ollama extends API_Wrapper {

    __New(host := "http://localhost:11434", apiKey := "ollama") {
        this.httpObj := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        this.host := host
        this.apiKey := apiKey
    }

    generate(request) {
        this.requiredParams(request, ["model"])
        return this.postJson("/api/generate", request)
    }

    chat(request) {
        this.requiredParams(request, ["model", "messages"])
        this.requiredParams(request.messages[request.messages.MaxIndex()], ["role", "content"])
        return this.postJson("/api/chat", request)
    }

    pull(request) {
        this.requiredParams(request, ["name"])
        return this.postJson("/api/pull", request)
    }

    push(request) {
        this.requiredParams(request, ["name"])
        return this.postJson("/api/push", request)
    }

    create(request) {
        this.requiredParams(request, ["name"])
        return this.postJson("/api/create", request)
    }

    delete(request) {
        this.requiredParams(request, ["name"])
        return this.postJson("/api/delete", request)
    }

    copy(request) {
        this.requiredParams(request, ["source", "destination"])
        return this.postJson("/api/copy", request)
    }

    list() {
        return this.getJson("/api/tags")
    }

    show(request) {
        this.checkParameters(request, ["name"])
        return this.postJson("/api/show", request)
    }

    embed(request) {
        this.requiredParams(request, ["model", "input"])
        return this.postJson("/api/embed", request)
    }

    ps() {
        return this.getJson("/api/ps")
    }

    ; not implemented - no endpoint?
    abort() {
        return
    }
}

; OpenAI class - Implements specific OpenAI endpoints
class OpenAI extends API_Wrapper {

    __New(host := "http://localhost:11434", apiKey := "YOUR_API_KEY") {
        this.httpObj := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        this.host := host
        this.apiKey := apiKey
    }

    chatCompletions(request) {
        this.requiredParams(request, ["model", "messages"])
        ;this.requiredParams()
        headers := { "Authorization": "Bearer " . this.apiKey }
        return this.postJson("/v1/chat/completions", request, headers)
    }

    completions(request) {
        this.requiredParams(request, ["model", "prompt"])
        headers := { "Authorization": "Bearer " . this.apiKey }
        return this.postJson("/v1/completions", request, headers)
    }

    models() {
        headers := { "Authorization": "Bearer " . this.apiKey }
        responseText := this.request("GET", this.host "/v1/models", headers)
        return JSON.Load(responseText)
    }

    model(modelName) {
        if (modelName == "") {
            MsgBox, 16, API Error, modelName is required.
            return
        }
        headers := { "Authorization": "Bearer " . this.apiKey }
        responseText := this.request("GET", this.host "/v1/models/" modelName, headers)
        return JSON.Load(responseText)
    }

    embeddings(request) {
        headers := { "Authorization": "Bearer " . this.apiKey }
        this.requiredParams(request, ["model", "input"])
        return this.postJson("/v1/embeddings", request, headers)
    }
}