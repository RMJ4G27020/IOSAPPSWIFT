//
//  AddExpenseView.swift
//  ExpenseTrackerApp
//
//  Created with GitHub Copilot assistance
//  Copyright © 2025 ExpenseTracker. All rights reserved.
//

import SwiftUI
import PhotosUI

struct AddExpenseView: View {
    @EnvironmentObject var viewModel: ExpenseTrackerViewModel
    @Environment(\.dismiss) private var dismiss
    
    // Form fields
    @State private var amount: String = ""
    @State private var description: String = ""
    @State private var selectedCategory: ExpenseCategory = .other
    @State private var selectedDate = Date()
    @State private var location: String = ""
    @State private var tags: String = ""
    @State private var isRecurring = false
    @State private var recurringFrequency: RecurringFrequency = .monthly
    
    // Photo picker
    @State private var selectedImageItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    // Form validation
    private var isFormValid: Bool {
        !amount.isEmpty && 
        Double(amount) != nil && 
        Double(amount)! > 0 &&
        !description.isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Amount Section
                Section("Monto") {
                    HStack {
                        Text(viewModel.userProfile?.currency.symbol ?? "$")
                            .font(.title2)
                            .foregroundColor(.secondaryText)
                        
                        TextField("0.00", text: $amount)
                            .keyboardType(.decimalPad)
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                }
                
                // Basic Info Section
                Section("Información Básica") {
                    TextField("Descripción", text: $description)
                        .textInputAutocapitalization(.sentences)
                    
                    Picker("Categoría", selection: $selectedCategory) {
                        ForEach(ExpenseCategory.allCases, id: \.self) { category in
                            Label(category.displayName, systemImage: category.icon)
                                .tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    DatePicker("Fecha", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                }
                
                // Optional Info Section
                Section("Información Adicional") {
                    TextField("Ubicación (opcional)", text: $location)
                        .textInputAutocapitalization(.words)
                    
                    TextField("Tags (separados por coma)", text: $tags)
                        .textInputAutocapitalization(.never)
                }
                
                // Photo Section
                Section("Foto del Recibo") {
                    HStack {
                        if let selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            Spacer()
                            
                            Button("Cambiar Foto") {
                                // Reset photo picker
                                selectedImageItem = nil
                                selectedImage = nil
                            }
                            .foregroundColor(.red)
                        } else {
                            PhotosPicker(
                                selection: $selectedImageItem,
                                matching: .images,
                                photoLibrary: .shared()
                            ) {
                                Label("Agregar Foto del Recibo", systemImage: "camera")
                                    .foregroundColor(.copilotBlue)
                            }
                        }
                    }
                }
                
                // Recurring Section
                Section("Gasto Recurrente") {
                    Toggle("Es un gasto recurrente", isOn: $isRecurring)
                    
                    if isRecurring {
                        Picker("Frecuencia", selection: $recurringFrequency) {
                            ForEach(RecurringFrequency.allCases, id: \.self) { frequency in
                                Text(frequency.displayName).tag(frequency)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
            }
            .navigationTitle("Nuevo Gasto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        saveExpense()
                    }
                    .disabled(!isFormValid)
                    .fontWeight(.semibold)
                }
            }
            .onChange(of: selectedImageItem) { newItem in
                Task {
                    if let newItem = newItem {
                        if let data = try? await newItem.loadTransferable(type: Data.self) {
                            selectedImage = UIImage(data: data)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Save Expense
    private func saveExpense() {
        guard let amountValue = Double(amount) else { return }
        
        var newExpense = Expense(
            amount: amountValue,
            category: selectedCategory,
            description: description,
            location: location.isEmpty ? nil : location
        )
        
        // Update date
        newExpense.date = selectedDate
        
        // Process tags
        if !tags.isEmpty {
            newExpense.tags = tags.components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
        }
        
        // Handle recurring
        newExpense.isRecurring = isRecurring
        if isRecurring {
            newExpense.recurringFrequency = recurringFrequency
        }
        
        // TODO: Save image to device and associate with expense
        if selectedImage != nil {
            // newExpense.receiptImage = savedImagePath
        }
        
        viewModel.addExpense(newExpense)
        dismiss()
    }
}

#Preview {
    AddExpenseView()
        .environmentObject(ExpenseTrackerViewModel())
}
