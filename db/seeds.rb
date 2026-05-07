require 'faker'

puts "Cleaning database..."
Treatment.destroy_all
Appointment.destroy_all
Pet.destroy_all
Vet.destroy_all
Owner.destroy_all

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
  # Determinamos el nombre del archivo basado en la especie de la mascota
  file_name = "#{pet.species}.jpg"
  image_path = Rails.root.join("db/seeds/pets", file_name)

  if File.exist?(image_path)
    # Usamos la firma de la API requerida por el lab: io, filename y content_type
    pet.photo.attach(
      io: File.open(image_path),
      filename: file_name,
      content_type: "image/jpeg"
    )
    puts "✅ Correct photo (#{file_name}) attached to #{pet.name} (#{pet.species})"
  else
    # Esto manejará casos como 'other' si no tienes un other.jpg
    puts "⚠️  No photo found for species '#{pet.species}' (looking for #{file_name})"
  end
end

puts "Creating appointments..."
5.times do |i|
  Appointment.create!(
    pet: Pet.all.sample,
    vet: Vet.all.sample,
    date: Faker::Time.between(from: DateTime.now - 1.month, to: DateTime.now + 1.month),
    reason: ["Annual Checkup", "Vaccination", "Injury", "General Consultation"].sample,
    status: [:scheduled, :in_progress, :completed, :cancelled].sample
  )
end

puts "Creating treatments..."
valid_appointments = Appointment.where.not(status: :cancelled).limit(5)

valid_appointments.each do |appointment|
  appointment.treatments.create!(
    name: ["Antibiotics", "Pain Relief", "Wound Cleaning", "Vitamin Boost"].sample,
    medication: Faker::Science.element,
    dosage: "#{rand(1..10)}ml every #{rand(4..12)} hours",
    notes: Faker::Lorem.paragraph(sentence_count: 2),
    administered_at: appointment.date + 1.hour
  )
end

puts "Seed finished! Created: #{Owner.count} owners, #{Pet.count} pets, #{Vet.count} vets, #{Appointment.count} appointments, and #{Treatment.count} treatments."
