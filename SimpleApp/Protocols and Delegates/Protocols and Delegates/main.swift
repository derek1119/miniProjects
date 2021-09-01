
protocol AdvancedLifeSupport {
    func performCPR()
    
}

class EmergencyCallHandler {
    var delegate: AdvancedLifeSupport?
    
    func assessSituation() {
        print("Can you tell me what heppened?")
    }
    
    func medicalEmergency() {
        delegate?.performCPR()
    }
}

struct Paramedic: AdvancedLifeSupport {
    
    init(hanlder: EmergencyCallHandler) {
        hanlder.delegate = self
    }
    
    func performCPR() {
        print("The paramedic does chst compressions, 30 per second")
    }
}



class Doctor: AdvancedLifeSupport {
    
    init(handler: EmergencyCallHandler) {
        handler.delegate = self
    }
    
    func performCPR() {
        print("Doctor ---> The paramedic does chst compressions, 30 per second")
    }
    
    func useStethescope() {
        print("Listening for heart sounds")
    }
}


class Surgeon: Doctor {
    override func performCPR() {
        super.performCPR()
        print("Sings staying alive by the Beegees")
    }
    
    func useElectricDrill() {
        print("Whirr...")
    }
}

let emilio = EmergencyCallHandler()
let angela = Surgeon(handler: emilio)


emilio.assessSituation()
emilio.medicalEmergency()
