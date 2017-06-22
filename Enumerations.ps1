Add-Type -TypeDefinition @"
[System.Flags]
public enum PanelStatus : int {
    Online = 1,
    OptionsMismatch = 2,
    CabinetTamper = 4,
    PowerFailure = 8,
    DownloadingFirmware = 10
}

[System.Flags]
public enum ReaderStatus : int {
	Online = 0x1,
	OptionsMismatch = 0x2,
	CabinetTamper = 0x4,
	PowerFail = 0x8,
	ReaderTamper = 0x10,
	DoorForced = 0x20,
	DoorHeld = 0x40,
	AuxInput1 = 0x80,
	AuxInput2 = 0x100,
	AuxInput3 = 0x400,
	BioVerify = 0x800,
	DCGroundFault = 0x1000,
	DCShortFault = 0x2000,
	DCOpenFault = 0x4000,
	DCGenericFault = 0x8000,
	RXGroundFault = 0x10000,
	RXShortFault = 0x20000,
	RXOpenFault = 0x40000,
	RXGenericFault = 0x80000,
	FirstCardUnlockMode = 0x100000,
	ExtendedHeldMode = 0x200000,
	CipherMode = 0x400000,
	LowBattery = 0x800000,
	MotorStalled = 0x1000000,
	ReadHeadOffline = 0x2000000,
	MRDTOffline = 0x4000000,
	DoorContactOffline = 0x8000000
}

public enum ReaderMode : int {
	Locked = 0,
	CardOnly = 1,
	PinOrCard = 2,
	PinAndCard = 3,
	Unlocked = 4,
	FacilityCodeOnly = 5,
	CypherLock = 6,
	Automatic = 7
}

public enum TimeAttandanceType : int {
	None = 0,
	EntranceReader = 1,
	ExitReader = 2
}

public enum AreaType : int {
	Other = 0,
	Unknown = 1,
	LocalArea = 2,
	GlobalArea = 3,
	HazardousLocation = 4,
	SafeLocation = 5
}

public enum DirectoryType : int {
	LDAP = 0,
	MicrosoftActiveDirectory = 1,
	MicrosoftWindowsNT = 2,
	MicrosoftLocalAccounts = 3,
	Domain = 4
}
"@