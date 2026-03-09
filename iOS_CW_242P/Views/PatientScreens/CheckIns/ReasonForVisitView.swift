//
//  Untitled.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-03-01.
//
import SwiftUI

enum CheckInPersonType: String, CaseIterable {
    case myself = "Myself"
    case anotherPerson = "Another Person"
    case child = "Child"
}

enum CheckInFlowType {
    case opd
    case lab(approvalRequiredTests: [LabTest])
}

struct ReasonForVisitView: View {
    @Binding var reasonForVisit: String
    let user: User?
    var flowType: CheckInFlowType = .opd
    @Binding var hasUploadedDocuments: Bool
    @Binding var isFormValid: Bool
    
    @State private var personType: CheckInPersonType = .myself
    @State private var name: String = ""
    @State private var nicOrAge: String = ""
    @State private var telephone: String = ""
    @State private var didPrefill = false
    
    private var inputBoxBgColor : Color{
        return .white.opacity(0.6)
    }

    private var approvalTests: [LabTest] {
        if case .lab(let tests) = flowType {
            return tests
        }
        return []
    }

    private var isLabFlow: Bool {
        if case .lab = flowType { return true }
        return false
    }

    private var approvalInstructionText: String {
        if approvalTests.count <= 1 {
            return "Please upload a doctor note so we can review and approve your test."
        }
        return "Please upload supporting documents so we can review and approve your tests."
    }

    private var uploadButtonTitle: String {
        approvalTests.count <= 1 ? "Upload Doctor Note" : "Upload Documents"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Visit Details")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(isLabFlow ? "Confirm who this check-in is for" : "Review your information and describe your visit")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Who is this for?")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)

                    HStack(spacing: 8) {
                        ForEach(CheckInPersonType.allCases, id: \.self) { type in
                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    personType = type
                                    handlePersonTypeChange()
                                }
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: personType == type ? "circle.inset.filled" : "circle")
                                        .foregroundColor(personType == type ? .blue : .gray)
                                        .font(.system(size: 16))
                                    Text(type.rawValue)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 4)
                            }
                        }
                    }
                }
                .padding(.horizontal)

                VStack(spacing: 16) {
                    CustomTextField(
                        title: "Full Name",
                        placeholder: personType == .child ? "Enter child's name" : "Enter full name",
                        text: $name,
                        icon: "person",
                        backgroundColor: inputBoxBgColor
                    )

                    if personType == .child {
                        CustomTextField(
                            title: "Age",
                            placeholder: "Enter child's age",
                            text: $nicOrAge,
                            icon: "person.crop.circle.badge.clock",
                            keyboardType: .numberPad,
                            backgroundColor: inputBoxBgColor
                        )
                    } else {
                        CustomTextField(
                            title: "NIC Number",
                            placeholder: "Enter NIC number",
                            text: $nicOrAge,
                            icon: "person.text.rectangle",
                            keyboardType: .default,
                            disableAutocapitalization: true,
                            backgroundColor: inputBoxBgColor
                        )
                    }

                    CustomTextField(
                        title: personType == .child ? "Guardian Phone Number" : "Telephone",
                        placeholder: personType == .child ? "Enter guardian's phone number" : "Enter phone number",
                        text: $telephone,
                        icon: "phone",
                        keyboardType: .phonePad,
                        backgroundColor: .white
                    )
                    
                }
                .padding(.horizontal)

                if isLabFlow && !approvalTests.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Action Required")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text(approvalInstructionText)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }

                        ForEach(approvalTests) { test in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(test.name)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    Text("\(test.duration) minutes")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text("Needs Approval")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                        }

                        Button {
                            hasUploadedDocuments = true
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: hasUploadedDocuments ? "checkmark.circle.fill" : "doc.badge.plus")
                                Text(hasUploadedDocuments ? "Documents Uploaded" : uploadButtonTitle)
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                        }
                        .buttonStyle(.bordered)
                        .tint(hasUploadedDocuments ? .green : .blue)

                        if !hasUploadedDocuments {
                            Text("You must upload documents before continuing.")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    .background(Color(.tertiarySystemFill))
                    .cornerRadius(12)
                    .padding(.horizontal)
                } else if !isLabFlow {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Reason for Visit")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)

                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "note.text")
                                .foregroundColor(.gray)
                                .frame(width: 20)
                                .padding(.top, 12)

                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $reasonForVisit)
                                    .frame(height: 120)
                                    .scrollContentBackground(.hidden)

                                if reasonForVisit.isEmpty {
                                    Text("Enter the reason for your visit...")
                                        .foregroundColor(.gray.opacity(0.5))
                                        .padding(.horizontal, 4)
                                        .padding(.vertical, 8)
                                        .allowsHitTesting(false)
                                }
                            }
                        }
                        .padding()
                        .background(inputBoxBgColor)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 40)
            .onAppear {
                if !didPrefill {
                    prefillForSelf()
                    didPrefill = true
                }
                updateFormValidity()
            }
            .onChange(of: name) { updateFormValidity() }
            .onChange(of: nicOrAge) { updateFormValidity() }
            .onChange(of: telephone) { updateFormValidity() }
            .onChange(of: reasonForVisit) { updateFormValidity() }
            .onChange(of: hasUploadedDocuments) { updateFormValidity() }
        }
    }

    private func prefillForSelf() {
        name = user?.name ?? ""
        telephone = user?.telephone ?? ""
        nicOrAge = ""
    }

    private func handlePersonTypeChange() {
        switch personType {
        case .myself:
            prefillForSelf()
        case .anotherPerson:
            name = ""
            nicOrAge = ""
            telephone = ""
        case .child:
            name = ""
            nicOrAge = ""
            telephone = ""
        }
    }

    private func updateFormValidity() {
        let fieldsValid = !name.trimmingCharacters(in: .whitespaces).isEmpty
            && !nicOrAge.trimmingCharacters(in: .whitespaces).isEmpty
            && !telephone.trimmingCharacters(in: .whitespaces).isEmpty

        if isLabFlow {
            if approvalTests.isEmpty {
                isFormValid = fieldsValid
            } else {
                isFormValid = fieldsValid && hasUploadedDocuments
            }
        } else {
            isFormValid = fieldsValid && !reasonForVisit.trimmingCharacters(in: .whitespaces).isEmpty
        }
    }
}

#Preview {
    ReasonForVisitView(
        reasonForVisit: .constant(""),
        user: nil,
        hasUploadedDocuments: .constant(false),
        isFormValid: .constant(false)
    )
}
