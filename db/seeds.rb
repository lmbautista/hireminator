# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.find_or_create_by(
  name: "Wadus",
  email: "wadushireminator-domain.com",
  password: SecureRandom.uuid,
  role: User::ROLE_CANDIDATE
)
use_case_name = "Entrevista ZARA"
inputs_zara = {
  "empresa" => "ZARA",
  "puesto" => "Responsable de zona",
  "horario" => "Lunes a Viernes de 9:00 a 18:00",
  "salario" => "30.000€",
  "experiencia" => "3 años",
  "idiomas" => "Inglés y Español"
}
outputs_zara = {
  "full_name" => "Nombre completo de la persona",
  "email" => "Email de la persona",
  "phone_number" => "Teléfono de la persona",
  "card_id" => "DNI/NIF de la persona",
  "full_address" => "Dirección completa de la persona",
  "city" => "Ciudad de la persona"
}

UseCase.new(
  name: use_case_name,
  provider: UseCase::PROVIDER_OPENAI,
  model: UseCase::MODEL_GPT4_MINI,
  purpose: UseCase::PURPOSE_INTERVIEW,
  locale: UseCase::LOCALE_ES,
  inputs: inputs_zara,
  outputs: outputs_zara
).save!

use_case_name = "Entrevista Huawei"
inputs_huawei = {
  "empresa" => "Huawei",
  "puesto" => "Operador telefónico",
  "horario" => "Lunes a Viernes de 8:00 a 15:00",
  "salario" => "42.000€",
  "experiencia" => "2 años",
  "idiomas" => "Inglés, Español y se valoran otros idiomas como Francés o Alemán"
}
outputs_huawei = {
  "full_name" => "Nombre completo de la persona",
  "email" => "Email de la persona",
  "phone_number" => "Teléfono de la persona",
  "card_id" => "DNI/NIF de la persona"
}

use_case = UseCase.new(
  name: use_case_name,
  provider: UseCase::PROVIDER_OPENAI,
  model: UseCase::MODEL_GPT4_MINI,
  purpose: UseCase::PURPOSE_INTERVIEW,
  locale: UseCase::LOCALE_ES,
  inputs: inputs_huawei,
  outputs: outputs_huawei
).save!


outputs_support_zara = {
  "doubts" => "Dudas expuestas en la conversación: horarios, contrato, salario, beneficios, documentación, otro...",
  "summary" => "Breve resumen del problema planteado ",
  "urgency" => "Nivel de urgencia del problema planteado (bajo, medio, alto)",
  "solved" => "Si el problema planteado ha sido resuelto o no",
  "scalation_required" => "true/false (si debe ser enviado al equipo humano)"
}

UseCase.new(
  name: "Soporte ZARA",
  provider: UseCase::PROVIDER_OPENAI,
  model: UseCase::MODEL_GPT4_MINI,
  purpose: UseCase::PURPOSE_SUPPORT,
  locale: UseCase::LOCALE_ES,
  inputs: inputs_zara,
  outputs: outputs_support_zara
).save!