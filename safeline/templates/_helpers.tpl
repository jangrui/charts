{{- define "safeline.name" -}}
{{- default "safeline" .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{- define "safeline.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "safeline" .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}


{{- define "safeline.labels" -}}
heritage: {{ .Release.Service }}
release: {{ .Release.Name }}
chart: {{ .Chart.Name }}
app: "{{ template "safeline.name" . }}"
{{- end -}}


{{- define "safeline.matchLabels" -}}
release: {{ .Release.Name }}
app: "{{ template "safeline.name" . }}"
{{- end -}}


{{/* database */}}
{{- define "safeline.database" -}}
  {{- printf "%s-database" (include "safeline.fullname" .) -}}
{{- end -}}

{{- define "safeline.database.host" -}}
  {{- if eq .Values.database.type "internal" -}}
    {{- printf "%s" "safeline-pg" }}
  {{- else -}}
    {{- .Values.database.external.host -}}
  {{- end -}}
{{- end -}}

{{- define "safeline.database.port" -}}
  {{- if eq .Values.database.type "internal" -}}
    {{- printf "%s" "5432" -}}
  {{- else -}}
    {{- .Values.database.external.port -}}
  {{- end -}}
{{- end -}}

{{- define "safeline.database.username" -}}
  {{- if eq .Values.database.type "internal" -}}
    {{- printf "%s" "safeline-ce" -}}
  {{- else -}}
    {{- .Values.database.external.username -}}
  {{- end -}}
{{- end -}}

{{- define "safeline.database.rawPassword" -}}
  {{- if eq .Values.database.type "internal" -}}
    {{- .Values.database.internal.password -}}
  {{- else -}}
    {{- .Values.database.external.password -}}
  {{- end -}}
{{- end -}}

{{- define "safeline.database.escapedRawPassword" -}}
  {{- include "safeline.database.rawPassword" . | urlquery | replace "+" "%20" -}}
{{- end -}}

{{- define "safeline.database.encryptedPassword" -}}
  {{- include "safeline.database.rawPassword" . | b64enc | quote -}}
{{- end -}}

{{- define "safeline.database.coreDatabase" -}}
  {{- if eq .Values.database.type "internal" -}}
    {{- printf "%s" "registry" -}}
  {{- else -}}
    {{- .Values.database.external.coreDatabase -}}
  {{- end -}}
{{- end -}}

{{- define "safeline.database.dbname" -}}
  {{- if eq .Values.database.type "internal" -}}
    {{- printf "%s" "safeline-ce" -}}
  {{- else -}}
    {{- .Values.database.external.dbname -}}
  {{- end -}}
{{- end -}}


{{- define "safeline.database.sslmode" -}}
  {{- if eq .Values.database.type "internal" -}}
    {{- printf "%s" "disable" -}}
  {{- else -}}
    {{- .Values.database.external.sslmode -}}
  {{- end -}}
{{- end -}}

{{- define "safeline.database.url" -}}
postgres://{{ template "safeline.database.username" . }}:{{ template "safeline.database.escapedRawPassword" . }}@{{ template "safeline.database.host" . }}:{{ template "safeline.database.port" . }}/{{ template "safeline.database.dbname" . }}?sslmode={{ template "safeline.database.sslmode" . }}
{{- end -}}


{{/* logs */}}
{{- define "safeline.logs" -}}
  {{- printf "%s-logs" (include "safeline.fullname" .) -}}
{{- end -}}


{{/* nginx */}}
{{- define "safeline.nginx" -}}
  {{- printf "%s-nginx" (include "safeline.fullname" .) -}}
{{- end -}}


{{/* mgt */}}
{{- define "safeline.mgt" -}}
  {{- printf "%s-mgt" (include "safeline.fullname" .) -}}
{{- end -}}

{{- define "safeline.mgt.api.port" -}}
    {{- printf "80" -}}
{{- end -}}

{{- define "safeline.mgt.web.port" -}}
    {{- printf "1443" -}}
{{- end -}}

{{- define "safeline.mgt.tcd.port" -}}
    {{- printf "8000" -}}
{{- end -}}

{{- define "safeline.mgt.api" -}}
https://{{ template "safeline.mgt" . }}:{{ template "safeline.mgt.web.port" . }}/api/open/publish/server
{{- end -}}

{{- define "safeline.mgt.tcd" -}}
  {{ template "safeline.mgt" . }}:{{ template "safeline.mgt.tcd.port" . }}
{{- end -}}


{{/* detector */}}
{{- define "safeline.detector" -}}
  {{- printf "%s-detector" (include "safeline.fullname" .) -}}
{{- end -}}

{{- define "safeline.detector.sns.port" -}}
    {{- printf "8001" -}}
{{- end -}}


{{/* mario */}}
{{- define "safeline.mario" -}}
  {{- printf "%s-mario" (include "safeline.fullname" .) -}}
{{- end -}}

{{- define "safeline.mario.port" -}}
    {{- printf "3335" -}}
{{- end -}}

{{- define "safeline.mario.url" -}}
http://{{ template "safeline.mario" . }}:{{ template "safeline.mario.port" . }}
{{- end -}}


{{/* tengine */}}
{{- define "safeline.tengine" -}}
  {{- printf "%s-tengine" (include "safeline.fullname" .) -}}
{{- end -}}

{{- define "safeline.tengine.health.port" -}}
    {{- printf "65443" -}}
{{- end -}}

{{- define "safeline.tengine.http.port" -}}
    {{- printf "80" -}}
{{- end -}}


{{/* fvm */}}
{{- define "safeline.fvm" -}}
  {{- printf "%s-fvm" (include "safeline.fullname" .) -}}
{{- end -}}

{{- define "safeline.fvm.api.port" -}}
    {{- printf "9004" -}}
{{- end -}}

{{- define "safeline.fvm.web.port" -}}
    {{- printf "80" -}}
{{- end -}}


{{/* luigi */}}
{{- define "safeline.luigi" -}}
  {{- printf "%s-luigi" (include "safeline.fullname" .) -}}
{{- end -}}

{{- define "safeline.luigi.port" -}}
    {{- printf "80" -}}
{{- end -}}
