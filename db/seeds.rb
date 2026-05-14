require 'faker'

puts "Cleaning database..."
User.destroy_all
Treatment.destroy_all
Appointment.destroy_all
Pet.destroy_all
Vet.destroy_all
Owner.destroy_all

puts "Creating users with different roles..."

# Admin User
User.create!(
  first_name: "Admin",
  last_name: "User",
  email: "admin@vetclinic.com",
  password: "password123",
  role: :admin
)

# Vet User
User.create!(
  first_name: "Vet",
  last_name: "User",
  email: "vet@vetclinic.com",
  password: "password123",
  role: :vet
)

# Owner User
User.create!(
  first_name: "Owner",
  last_name: "User",
  email: "owner@vetclinic.com",
  password: "password123",
  role: :owner
)

puts "✅ Created 3 users (Admin, Vet, Owner). Password: 'password123'"

puts "Creating vets..."
2.times do
  Vet.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.unique.email,
    phone: Faker::PhoneNumber.cell_phone,
    specialization: ["General Practice", "Surgery", "Dermatology", "Oncology"].sample
  )
end

puts "Creating owners and pets..."
owners = []
3.times do
  owner = Owner.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.unique.email,
    phone: Faker::PhoneNumber.cell_phone,
    address: Faker::Address.full_address
  )
  owners << owner
end

species_options = ["dog", "cat", "rabbit", "bird", "reptile", "other"]
5.times do
  Pet.create!(
    owner: owners.sample,
    name: Faker::Creature::Dog.name,
    species: species_options.sample,
    breed: Faker::Creature::Dog.breed,
    date_of_birth: Faker::Date.between(from: 10.years.ago, to: Date.today),
    weight: rand(1.5..40.0).round(2)
  )
end

puts "Attaching photos to pets by species..."
Pet.all.each do |pet|
  file_name = "#{pet.species}.jpg"
  image_path = Rails.root.join("db/seeds/pets", file_name)

  if File.exist?(image_path)
    pet.photo.attach(
      io: File.open(image_path),
      filename: file_name,
      content_type: "image/jpeg"
    )
    puts "✅ Correct photo (#{file_name}) attached to #{pet.name} (#{pet.species})"
  else
    puts "⚠️  No photo found for species '#{pet.species}'"
  end
end

puts "Creating appointments..."
5.times do
  Appointment.create!(
    pet: Pet.all.sample,
    vet: Vet.all.sample,
    date: Faker::Time.between(from: DateTime.now - 1.month, to: DateTime.now + 1.month),
    reason: ["Annual Checkup", "Vaccination", "Injury", "General Consultation"].sample,
    status: [:scheduled, :in_progress, :completed, :cancelled].sample
  )
end

puts "Creating treatments with realistic notes..."
observations = [
  "Patient shows signs of mild dehydration and lethargy.",
  "Heart rate is stable, no murmurs or arrhythmias detected.",
  "Incision site is healing well with no signs of infection."
]

recommendations = [
  "Monitor water intake closely over the next 48 hours.",
  "Strict rest: limit physical activity for one week.",
  "Continue prescribed medication."
]

valid_appointments = Appointment.where.not(status: :cancelled).limit(5)
valid_appointments.each do |appointment|
  obs = observations.sample
  rec = recommendations.sample

  appointment.treatments.create!(
    name: ["Antibiotics", "Pain Relief", "Wound Cleaning"].sample,
    medication: Faker::Science.element,
    dosage: "#{rand(1..10)}ml every #{rand(4..12)} hours",
    clinical_notes: "<h5>Clinical Observation</h5><p>#{obs}</p><h6>Plan:</h6><ul><li>#{rec}</li></ul>",
    administered_at: appointment.date + 1.hour
  )
end

puts "Seed finished! Created: #{User.count} users, #{Owner.count} owners, #{Pet.count} pets, #{Vet.count} vets, #{Appointment.count} appointments, and #{Treatment.count} treatments."
