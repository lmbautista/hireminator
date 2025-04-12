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
inputs = {
  "empresa" => "ZARA",
  "puesto" => "Responsable de zona",
  "horario" => "Lunes a Viernes de 9:00 a 18:00",
  "salario" => "30.000€",
  "experiencia" => "3 años",
  "idiomas" => "Inglés y Español"
}
outputs = {
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
  inputs:,
  outputs:
).save!

use_case_name = "Entrevista Huawei"
inputs = {
  "empresa" => "Huawei",
  "puesto" => "Operador telefónico",
  "horario" => "Lunes a Viernes de 8:00 a 15:00",
  "salario" => "42.000€",
  "experiencia" => "2 años",
  "idiomas" => "Inglés, Español y se valoran otros idiomas como Francés o Alemán"
}
outputs = {
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
  inputs:,
  outputs:
).save!
