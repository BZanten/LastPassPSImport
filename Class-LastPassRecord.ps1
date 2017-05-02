
#
# https://xainey.github.io/2016/powershell-classes-and-concepts/
#

#
#  A Normal LastPass Record has 7 fields.
#   the Url property can have any value, that becomes the URL field
#   the Extra property can have any value, that becomes the Note field
#
class LastPassRecord {
    [string]$Url;
    [string]$UserName;
    [string]$Password;
    [string]$Name;
    [string]$Grouping;
    [UInt32]$Fav;
    [string]$Extra;
	
    hidden [System.Globalization.CultureInfo]$Culture = 'en-US'

    #
    # Constructor
    #
    LastPassRecord(  ) {
        $this.Fav = 0;
    }

    # ToString()  Method
    [string]ToString() {
        return $this.Name
    }
}

#
# From here: Secure notes
#    Generic secure note:
#    URL property must be http://sn
#    Extra property will get special additional fields depending on the type of secure note.
#
class LPGeneric : LastPassRecord {

    #
    # Dynamic calculation of the 'Extra' Property.
    #  Code inspired by: http://stackoverflow.com/questions/39717230/powershell-class-implement-get-set-property
    #   Have to use -Force to override the existing Extra property in the base class-implement-get-set-property
	#
    hidden    [string]$_Extra = $($this | Add-Member -MemberType ScriptProperty -Force -Name 'Extra' `
              -Value { $this._Extra }`
        -SecondValue { param ( $arg ) $this._Extra = $arg  }  )

    # Constructor:
    LPGeneric(  ) : base() {
        $this.Url = 'http://sn'
    }
}

#
# Todo: below
# *  make the URL,NoteType and Extra properties readonly
# *  sometimes the UserName and/or Password property is unneeded. Remove or make readonly?

class LPBankAccount : LastPassRecord {

    [string]$NoteType
    [string]$BankName
    [string]$AccountType
    [string]$RoutingNumber
    [string]$AccountNumber
    [string]$SWIFTCode
    [string]$IBANNumber
    [string]$Pin
    [string]$BranchAddress
    [string]$BranchPhone
    [string]$Notes

    hidden    [string]$_Extra = $($this | Add-Member -MemberType ScriptProperty -Force -Name 'Extra' `
              -Value { $this.CalculateExtra() ; $this._Extra }`
        -SecondValue { param ( $arg ) $this._Extra = $arg  }  )

    # Constructor:
    LPBankAccount(  ) : base() {
        $this.url = 'http://sn'
        $this.NoteType='Bank Account'
    }

    #
    # Method to recalculate Extra field
    #
    [void]CalculateExtra(){
        $this._Extra="NoteType:$($this.NoteType)
Bank Name:$($this.BankName)
Account Type:$($this.AccountType)
Routing Number:$($this.RoutingNumber)
Account Number:$($this.AccountNumber)
SWIFT Code:$($this.SWIFTCode)
IBAN Number:$($this.IBANNumber)
Pin:$($this.Pin)
Branch Address:$($this.BranchAddress)
Branch Phone:$($this.BranchPhone)
Notes:$($this.Notes)"
    }
}

class LPCreditCard : LastPassRecord {

    [string]$NoteType
    [string]$NameOnCard
    [string]$Type
    [string]$Number
    [string]$SecurityCode
    [datetime]$StartDate
    [datetime]$ExpirationDate
    [string]$Notes

    hidden  [string]$_Extra = $($this | Add-Member -MemberType ScriptProperty -Force -Name 'Extra' `
              -Value { $this.CalculateExtra() ; $this._Extra }`
        -SecondValue { param ( $arg ) $this._Extra = $arg  }  )

    # Constructor:
    LPCreditCard(  ) : base() {
        $this.url = 'http://sn'
        $this.NoteType='Credit Card'
    }

    #
    # Method to recalculate Extra field
    #
    [void]CalculateExtra(){
        $this._Extra="NoteType:$($this.NoteType)
Name on Card:$($this.NameOnCard)
Type:$($this.Type)
Number:$($this.Number)
Security Code:$($this.SecurityCode)
Start Date:$(($this.StartDate).ToString("MMMM,yyyy",$this.Culture))
Expiration Date:$(($this.ExpirationDate).ToString("MMMM,yyyy",$this.Culture))
Notes:$($this.Notes)"
    }
}

class LPDatabase : LastPassRecord {

    [string]$NoteType
    [string]$Type
    [string]$Hostname
    [string]$Port
    [string]$Database
    [string]$SID
    [string]$Alias
    [string]$Notes

    hidden  [string]$_Extra = $($this | Add-Member -MemberType ScriptProperty -Force -Name 'Extra' `
              -Value { $this.CalculateExtra() ; $this._Extra }`
        -SecondValue { param ( $arg ) $this._Extra = $arg  }  )

    # Constructor:
    LPDatabase(  ) : base() {
        $this.url = 'http://sn'
        $this.NoteType='Database'
    }

    #
    # Method to recalculate Extra field
    #
    [void]CalculateExtra(){
        $this._Extra="NoteType:$($this.NoteType)
Type:$($this.Type)
Hostname:$($this.Hostname)
Port:$($this.Port)
Database:$($this.Database)
Username:$($this.Username)
Password:$($this.Password)
SID:$($this.SID)
Alias:$($this.Alias)
Notes:$($this.Notes)"
    }
}

class LPDriversLicense : LastPassRecord {

    [string]$NoteType
    [string]$Number
    [datetime]$ExpirationDate
    [string]$LicenseClass
    [string]$NameOnCard
    [string]$Address
    [string]$CityTown
    [string]$State
    [string]$ZipPostalCode
    [string]$Country
    [datetime]$DateOfBirth
    [string]$Sex
    [string]$Height
    [string]$Notes

    hidden  [string]$_Extra = $($this | Add-Member -MemberType ScriptProperty -Force -Name 'Extra' `
              -Value { $this.CalculateExtra() ; $this._Extra }`
        -SecondValue { param ( $arg ) $this._Extra = $arg  }  )

    # Constructor:
    LPDriversLicense (  ) : base() {
        $this.url = 'http://sn'
        $this.NoteType="Driver's License"
    }

    #
    # Method to recalculate Extra field
    #
    [void]CalculateExtra(){
        $this._Extra="NoteType:$($this.NoteType)
Number:$($this.Number)
Expiration Date:$(($this.ExpirationDate).ToString("MMMM,dd,yyyy",$this.Culture))
License Class:$($this.LicenseClass)
Name:$($this.NameOnCard)
Address:$($this.Address)
City / Town:$($this.CityTown)
State:$($this.State)
ZIP / Postal Code:$($this.ZipPostalCode)
Country:$($this.Country)
Date of Birth:$(($this.DateOfBirth).ToString("MMMM,dd,yyyy",$this.Culture))
Sex:$($this.Sex)
Height:$($this.Height)
Notes:$($this.Notes)"
    }
}


class LPEmailAccount : LastPassRecord {

    [string]$NoteType
    [string]$Server
    [string]$Port
    [string]$Type
    [string]$SMTPServer
    [string]$SMTPPort
    [string]$Notes

    hidden  [string]$_Extra = $($this | Add-Member -MemberType ScriptProperty -Force -Name 'Extra' `
              -Value { $this.CalculateExtra() ; $this._Extra }`
        -SecondValue { param ( $arg ) $this._Extra = $arg  }  )

    # Constructor:
    LPEmailAccount (  ) : base() {
        $this.url = 'http://sn'
        $this.NoteType="Email Account"
    }

    #
    # Method to recalculate Extra field
    #
    [void]CalculateExtra(){
        $this._Extra="NoteType:$($this.NoteType)
Username:$($this.UserName)
Password:$($this.Password)
Server:$($this.Server)
Port:$($this.Port)
Type:$($this.Type)
SMTP Server:$($this.SMTPServer)
SMTP Port:$($this.SMTPPort)
Notes:$($this.Notes)"
    }
}

class LPHealthInsurance : LastPassRecord {

    [string]$NoteType
    [string]$CompanyName
    [string]$CompanyPhone
    [string]$PolicyType
    [string]$PolicyNumber
    [string]$GroupID
    [string]$MemberName
    [string]$MemberID
    [string]$PhysicianName
    [string]$PhysicianPhone
    [string]$PhysicianAddress
    [string]$CoPay
    [string]$Notes

    hidden  [string]$_Extra = $($this | Add-Member -MemberType ScriptProperty -Force -Name 'Extra' `
              -Value { $this.CalculateExtra() ; $this._Extra }`
        -SecondValue { param ( $arg ) $this._Extra = $arg  }  )

    # Constructor:
    LPHealthInsurance (  ) : base() {
        $this.url = 'http://sn'
        $this.NoteType="Health Insurance"
    }

    #
    # Method to recalculate Extra field
    #
    [void]CalculateExtra(){
        $this._Extra="NoteType:$($this.NoteType)
Company:$($this.CompanyName)
Company Phone:$($this.CompanyPhone)
Policy Type:$($this.PolicyType)
Policy Number:$($this.PolicyNumber)
Group ID:$($this.GroupID)
Member Name:$($this.MemberName)
Member ID:$($this.MemberID)
Physician Name:$($this.PhysicianName)
Physician Phone:$($this.PhysicianPhone)
Physician Address:$($this.PhysicianAddress)
Co-pay:$($this.CoPay)
Notes:$($this.Notes)"
    }
}

class LPInstantMessenger : LastPassRecord {

    [string]$NoteType
    [string]$Type
    [string]$Server
    [string]$Port
    [string]$Notes

    hidden  [string]$_Extra = $($this | Add-Member -MemberType ScriptProperty -Force -Name 'Extra' `
              -Value { $this.CalculateExtra() ; $this._Extra }`
        -SecondValue { param ( $arg ) $this._Extra = $arg  }  )

    # Constructor:
    LPInstantMessenger (  ) : base() {
        $this.url = 'http://sn'
        $this.NoteType="Instant Messenger"
    }

    #
    # Method to recalculate Extra field
    #
    [void]CalculateExtra(){
        $this._Extra="NoteType:$($this.NoteType)
Type:$($this.Type)
Username:$($this.UserName)
Password:$($this.Password)
Server:$($this.Server)
Port:$($this.Port)
Notes:$($this.Notes)"
    }
}

class LPInsurance : LastPassRecord {

    [string]$NoteType
    [string]$Company
    [string]$PolicyType
    [string]$PolicyNumber
    [datetime]$Expiration
    [string]$AgentName
    [string]$AgentPhone
    [string]$Website
    [string]$Notes

    hidden  [string]$_Extra = $($this | Add-Member -MemberType ScriptProperty -Force -Name 'Extra' `
              -Value { $this.CalculateExtra() ; $this._Extra }`
        -SecondValue { param ( $arg ) $this._Extra = $arg  }  )

    # Constructor:
    LPInsurance (  ) : base() {
        $this.url = 'http://sn'
        $this.NoteType="Insurance"
    }

    #
    # Method to recalculate Extra field
    #
    [void]CalculateExtra(){
        $this._Extra="NoteType:$($this.NoteType)
Company:$($this.Company)
Policy Type:$($this.PolicyType)
Policy Number:$($this.PolicyNumber)
Expiration:$(($this.Expiration).ToString("MMMM,dd,yyyy",$this.Culture))
Agent Name:$($this.AgentName)
Agent Phone:$($this.AgentPhone)
URL:$($this.Website)
Notes:$($this.Notes)"
    }
}

class LPMembership : LastPassRecord {

    [string]$NoteType
    [string]$Organization
    [string]$MembershipNumber
    [string]$MemberName
    [datetime]$StartDate
    [datetime]$ExpirationDate
    [string]$Website
    [string]$Telephone
    [string]$Notes

    hidden  [string]$_Extra = $($this | Add-Member -MemberType ScriptProperty -Force -Name 'Extra' `
              -Value { $this.CalculateExtra() ; $this._Extra }`
        -SecondValue { param ( $arg ) $this._Extra = $arg  }  )

    # Constructor:
    LPMembership (  ) : base() {
        $this.url = 'http://sn'
        $this.NoteType="Membership"
    }

    #
    # Method to recalculate Extra field
    #
    [void]CalculateExtra(){
        $this._Extra="NoteType:$($this.NoteType)
Organization:$($this.Organization)
Membership Number:$($this.MembershipNumber)
Member Name:$($this.MemberName)
Start Date:$(($this.StartDate).ToString("MMMM,dd,yyyy",$this.Culture))
Expiration Date:$(($this.ExpirationDate).ToString("MMMM,dd,yyyy",$this.Culture))
Website:$($this.Website)
Telephone:$($this.Telephone)
Password:$($this.Password)
Notes:$($this.Notes)"
    }
}

class LPPassport : LastPassRecord {

    [string]$NoteType
    [string]$Type
    [string]$NameOnPassPort
    [string]$Country
    [string]$Number
    [string]$Sex
    [string]$Nationality
    [string]$IssuingAuthority
    [datetime]$DateOfBirth
    [datetime]$IssuedDate
    [datetime]$ExpirationDate
    [string]$Notes

    hidden    [string]$_Extra = $($this | Add-Member -MemberType ScriptProperty -Force -Name 'Extra' `
        -Value {
            # get
            $this.CalculateExtra()
            $this._Extra
        }`
        -SecondValue {
            # set
            param ( $arg )
            $this._Extra = $arg
        }
    )

    # Constructor:
    LPPassport(  ) : base() {
        $this.url = 'http://sn'
        $this.NoteType='Passport'
    }

    #
    # Method to recalculate Extra field
    #
    [void]CalculateExtra(){
        $this._Extra="NoteType:$($this.NoteType)
Type:$($this.Type)
Name:$($this.NameOnPassPort)
Country:$($this.Country)
Number:$($this.Number)
Sex:$($this.Sex)
Nationality:$($this.Nationality)
Issuing Authority:$($this.IssuingAuthority)
Date of Birth:$(($this.DateOfBirth).ToString("MMMM,dd,yyyy",$this.Culture))
Issued Date:$(($this.IssuedDate).ToString("MMMM,dd,yyyy",$this.Culture))
Expiration Date:$(($this.ExpirationDate).ToString("MMMM,dd,yyyy",$this.Culture))
Notes:$($this.Notes)"
    }
}


class LPServer : LastPassRecord {

    [string]$NoteType
    [string]$Hostname
    [string]$Notes

    hidden    [string]$_Extra = $($this | Add-Member -MemberType ScriptProperty -Force -Name 'Extra' `
              -Value { $this.CalculateExtra() ; $this._Extra }`
        -SecondValue { param ( $arg ) $this._Extra = $arg  }  )

    # Constructor:
    LPServer(  ) : base() {
        $this.url = 'http://sn'
        $this.NoteType='Server'
    }

    #
    # Method to recalculate Extra field
    #
    [void]CalculateExtra(){
        $this._Extra="NoteType:$($this.NoteType)
Hostname:$($this.Hostname)
Username:$($this.UserName)
Password:$($this.Password)
Notes:$($this.Notes)"
    }

}

class LPSoftwareLicense : LastPassRecord {

    [string]$NoteType
    [string]$LicenseKey
    [string]$Licensee
    [string]$Version
    [string]$Publisher
    [string]$SupportEmail
    [string]$Website
    [string]$Price
    [datetime]$PurchaseDate
    [string]$OrderNumber
    [string]$NumberOfLicenses
    [string]$OrderTotal
    [string]$Notes

    hidden    [string]$_Extra = $($this | Add-Member -MemberType ScriptProperty -Force -Name 'Extra' `
        -Value {
            # get
            $this.CalculateExtra()
            $this._Extra
        }`
        -SecondValue {
            # set
            param ( $arg )
            $this._Extra = $arg
        }
    )

    # Constructor:
    LPSoftwareLicense(  ) : base() {
        $this.url = 'http://sn'
        $this.NoteType='Software License'
        $this.PurchaseDate = '1 January 2000'
    }

    #
    # Method to recalculate Extra field
    #
    [void]CalculateExtra(){
        $this._Extra="NoteType:$($this.NoteType)
License Key:$($this.LicenseKey)
Licensee:$($this.Licensee)
Version:$($this.Version)
Publisher:$($this.Publisher)
Support Email:$($this.SupportEmail)
Website:$($this.Website)
Price:$($this.Price)
Purchase Date:$(($this.PurchaseDate).ToString("MMMM,dd,yyyy",$this.Culture))
Order Number:$($this.OrderNumber)
Number of Licenses:$($this.NumberOfLicenses)
Order Total:$($this.OrderTotal)
Notes:$($this.Notes)"
    }
}


class LPSSHKey : LastPassRecord {

    [string]$NoteType
    [string]$BitStrength
    [string]$Format
    [string]$Passphrase
    [string]$PrivateKey
    [string]$PublicKey
    [string]$Hostname
    [datetime]$Date
    [string]$Notes

    hidden  [string]$_Extra = $($this | Add-Member -MemberType ScriptProperty -Force -Name 'Extra' `
              -Value { $this.CalculateExtra() ; $this._Extra }`
        -SecondValue { param ( $arg ) $this._Extra = $arg  }  )

    # Constructor:
    LPSSHKey (  ) : base() {
        $this.url = 'http://sn'
        $this.NoteType="SSH Key"
    }

    #
    # Method to recalculate Extra field
    #
    [void]CalculateExtra(){
        $this._Extra="NoteType:$($this.NoteType)
Bit Strength:$($this.BitStrength)
Format:$($this.Format)
Passphrase:$($this.Passphrase)
Private Key:$($this.PrivateKey)
Public Key:$($this.PublicKey)
Hostname:$($this.HostName)
Date:$(($this.Date).ToString("MMMM,dd,yyyy",$this.Culture))
Notes:$($this.Notes)"
    }
}

class LPSocialSecurity : LastPassRecord {

    [string]$NoteType
    [string]$MemberName
    [string]$Number
    [string]$Notes

    hidden  [string]$_Extra = $($this | Add-Member -MemberType ScriptProperty -Force -Name 'Extra' `
              -Value { $this.CalculateExtra() ; $this._Extra }`
        -SecondValue { param ( $arg ) $this._Extra = $arg  }  )

    # Constructor:
    LPSocialSecurity (  ) : base() {
        $this.url = 'http://sn'
        $this.NoteType="Social Security"
    }

    #
    # Method to recalculate Extra field
    #
    [void]CalculateExtra(){
        $this._Extra="NoteType:$($this.NoteType)
Name:$($this.MemberName)
Number:$($this.Number)
Notes:$($this.Notes)"
    }
}

class LPWiFiPassword : LastPassRecord {

    [string]$NoteType
    [string]$SSID
    [string]$ConnectionType
    [string]$ConnectionMode
    [string]$Authentication
    [string]$Encryption
    [string]$Use8021X
    [string]$FIPSMode
    [string]$KeyType
    [string]$Protected
    [string]$KeyIndex
    [string]$Notes

    hidden  [string]$_Extra = $($this | Add-Member -MemberType ScriptProperty -Force -Name 'Extra' `
              -Value { $this.CalculateExtra() ; $this._Extra }`
        -SecondValue { param ( $arg ) $this._Extra = $arg  }  )

    # Constructor:
    LPWiFiPassword (  ) : base() {
        $this.url = 'http://sn'
        $this.NoteType="Wi-Fi Password"
    }

    #
    # Method to recalculate Extra field
    #
    [void]CalculateExtra(){
        $this._Extra="NoteType:$($this.NoteType)
SSID:$($this.SSID)
Password:$($this.Password)
Connection Type:$($this.ConnectionType)
Connection Mode:$($this.ConnectionMode)
Authentication:$($this.Authentication)
Encryption:$($this.Encryption)
Use 802.1X:$($this.Use8021X)
FIPS Mode:$($this.FIPSMode)
Key Type:$($this.KeyType)
Protected:$($this.Protected)
Key Index:$($this.KeyIndex)
Notes:$($this.Notes)"
    }
}

