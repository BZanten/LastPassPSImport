# LastPass Password and secure note import.

A PowerShell script defining LastPass records, that can be used to import Records into LastPass.

I've been searching for a PowerShell module to manage LastPass, but couldn't find one.
What I did find was a unix shell tool to manage LastPass, but that doesn't work for me on Windows.

I did find out that LastPass has an easy CSV import utility.
LastPass also provides CSV templates for different kind of records, but these templates turned out to be incomplete and sometimes contained errors.

So I decided to build my own, with the following properties:
- Use PowerShell (v5.0) Class to create different kind of LastPass objects 
- use inheritance to inherit common attributes.
- Simply create a PowerShell object from this class
- Use Export-CSV to export to CSV
- Use the LastPass Import CSV method to import the data.

An example:


. .\Class-LastPassRecord.ps1

'''
$Rec1 = New-Object -TypeName LastPassRecord
$Rec1.Name="My Generic LastPass record"
$Rec1.UserName="BZanten"
$Rec1.Password="MyP@ssWr0d"
$Rec1.Fav=0
$Rec1.Grouping="AAA Test notities"
$Rec1.Url="http://www.mynetwork.local"
$Rec1.Extra="Extra informatie"
$Rec1
$Rec1   | Select-Object -Property Url,UserName,Password,Extra,Name,Grouping,Fav | ConvertTo-Csv -NoTypeInformation | Clip
'''

Now the data is in the clipboard.
Use Chrome to import the data :
- Login into LastPass using Chrome
  - LastPass Icon -> Options -> Advanced -> Import -> Other
  - Source: Generic CSV File
  - Content: Paste your text
  
Then import the data.

You can easily create multiple PowerShell objects and pipe them to ConvertTo-CSV if you want to add other records as well.

To import other record types (Secure Notes) to LastPass:

Always first import the Class into your session:
'''
. .\Class-LastPassRecord.ps1
'''

Then create a Generic Secure Note:

'''
$Rec2 = New-Object -TypeName LPGeneric
$Rec2.Name = "My Generic LastPass Secure Note"
$Rec2.Fav=0
$Rec2.Extra="Extra informatie"
$Rec2.Grouping="AAA Test notities"
# $Rec2.UserName="BZanten"
# $Rec2.Password="MyP@ssWr0d"
# $Rec2.Url="http://www.mynetwork.local"
$Rec2
$Rec2   | Select-Object -Property Url,UserName,Password,Extra,Name,Grouping,Fav | ConvertTo-Csv -NoTypeInformation | Clip
'''

To create a Software License secure note:

'''
$Rec3 = New-Object -TypeName LPSoftwareLicense
$Rec3.Website = 'https://my.visualstudio.com/productkeys'
$Rec3.LicenseKey='AAAAA-BBBBB-CCCCC-DDDDD-EEEEE'
$Rec3.Name = "My Software License"
$Rec3.Version = "v2013"
$Rec3.Grouping="AAA Test notities"
$Rec3
$Rec3   | Select-Object -Property Url,UserName,Password,Extra,Name,Grouping,Fav | ConvertTo-Csv -NoTypeInformation | Clip
'''

To create a Passport secure note:
'''
$Rec4 = New-Object -TypeName LPPassport
$Rec4.Type="Paspoort"
$Rec4.NameOnPassPort="B. v. Zanten"
$Rec4.IssuingAuthority="Gemeente Alhier"
$Rec4.Country="Nederland"
$Rec4.DateOfBirth="26 june 1960"
$Rec4.ExpirationDate="1 jan 2020"
$Rec4.Grouping="AAA Test notities"
$Rec4.IssuedDate="13 apr 2017"
$Rec4.Name="My Paspoort"
$Rec4.Sex='M'
$Rec4.Number=13
$Rec4.Nationality="Nederlandse"
$Rec4
$Rec4   | Select-Object -Property Url,UserName,Password,Extra,Name,Grouping,Fav | ConvertTo-Csv -NoTypeInformation | Clip
'''

To create a Server secure note:
'''
$Rec5 = New-Object -TypeName LPServer
$Rec5.Hostname="Server1.mynetwork.local"
$Rec5.UserName="MyNetwork\Administrator"
$Rec5.Password="MyP@ssWr0d"
$Rec5.Notes="Test1 server"
$Rec5.Name="My Test2 server username"
$Rec5.Grouping="AAA Test notities"
$Rec5
$Rec5   | Select-Object -Property Url,UserName,Password,Extra,Name,Grouping,Fav | ConvertTo-Csv -NoTypeInformation | Clip
'''

$Rec6 = New-Object -TypeName LPBankAccount
$Rec6.BankName='RaboBank'
$Rec6.AccountType='Spaarrekening'
$Rec6.RoutingNumber='route 123'
$Rec6.AccountNumber='336112345'
$Rec6.SWIFTCode='SWF2234'
$Rec6.IBANNumber='NLRABO234124324'
$Rec6.Pin='12345'
$Rec6.BranchAddress='Adresstraat 1'
$Rec6.BranchPhone='040 12341234'
$Rec6.Notes='RaboNote'
$Rec6.Name='My Bank account 1'
$Rec6.Grouping='AAA Test notities'
$Rec6
$Rec6   | Select-Object -Property Url,UserName,Password,Extra,Name,Grouping,Fav | ConvertTo-Csv -NoTypeInformation | Clip
'''

To create a CreditCard secure note:

'''
$Rec7 = New-Object -TypeName LPCreditCard
$Rec7.Name="My CreditCard"
$Rec7.ExpirationDate='1 mar 2020'
$Rec7.Grouping="AAA Test notities"
$Rec7.NameOnCard="B. v. Zanten"
$Rec7.Notes="een blauwe CC"
$Rec7.Number=123456789
$Rec7.Password="MyP@ssWr0d"
$Rec7.SecurityCode='393'
$Rec7.StartDate='1 feb 2014'
$Rec7.Type='RaboCard'
$Rec7.UserName='BZanten'
$Rec7   | Select-Object -Property Url,UserName,Password,Extra,Name,Grouping,Fav | ConvertTo-Csv -NoTypeInformation | Clip
'''

To create a Database secure note:

'''
$Rec8 = New-Object -TypeName LPDatabase
$Rec8.Type="SQL Server"
$Rec8.Hostname="SQLSVR001"
$Rec8.Port="1433"
$Rec8.Database="DB1"
$Rec8.SID="12341251512354"
$Rec8.Alias="ApplDb"
$Rec8.Notes="Database notitie"
$Rec8.UserName="sa"
$Rec8.Password="MyP@ssWr0d"
$Rec8.Name="My Database test"
$Rec8.Grouping="AAA Test notities"
$Rec8
$Rec8  | Select-Object -Property Url,UserName,Password,Extra,Name,Grouping,Fav | ConvertTo-Csv -NoTypeInformation | Clip
'''

To create a Drivers License secure note:

'''
$Rec9 = New-Object -TypeName LPDriversLicense
$Rec9.Number="NumberLic1"
$Rec9.ExpirationDate="31 dec 2018"
$Rec9.LicenseClass="ABE"
$Rec9.NameOnCard="B. v. Zanten"
$Rec9.Name="My DriversLicense 1"
$Rec9.Address="Adresstraat 1"
$Rec9.CityTown="Alhier"
$Rec9.State="NB"
$Rec9.ZipPostalCode="5300 AA"
$Rec9.Country="Netherlands"
$Rec9.DateOfBirth="26 may 1963"
$Rec9.Sex="M"
$Rec9.Height=1.81
$Rec9.Notes="Notitiione 1"
$Rec9.UserName="BZanten"
$Rec9.Password="MyP@ssWr0d"
$Rec9.Grouping="AAA Test notities"
$Rec9
$Rec9  | Select-Object -Property Url,UserName,Password,Extra,Name,Grouping,Fav | ConvertTo-Csv -NoTypeInformation | Clip
'''

To create an Email Account secure note:

'''
$Rec10 = New-Object -TypeName LPEmailAccount
$Rec10.Server="Mail.mynetwork.local"
$Rec10.Port=25
$Rec10.Type="SMTP"
$Rec10.SMTPServer="smtp.mynetwork.local"
$Rec10.SMTPPort=21
$Rec10.Notes="test mail server"
$Rec10.UserName="BZanten"
$Rec10.Password="MyP@ssWr0d"
$Rec10.Name="My Email adres test server"
$Rec10.Grouping="AAA Test notities"
$Rec10
$Rec10 | Select-Object -Property Url,UserName,Password,Extra,Name,Grouping,Fav | ConvertTo-Csv -NoTypeInformation | Clip
'''

To create a Health Insurance secure note:

'''
$Rec11 = New-Object -TypeName LPHealthInsurance
$Rec11.CompanyName="Dokter een"
$Rec11.CompanyPhone="Tel 1234"
$Rec11.PolicyType="Ziektekosten"
$Rec11.PolicyNumber="ZFW 1-23423"
$Rec11.GroupID="GroupID"
$Rec11.MemberName="MemberName"
$Rec11.MemberID="MemberID"
$Rec11.PhysicianName="PhysicianName"
$Rec11.PhysicianPhone="PhysicianPhone"
$Rec11.PhysicianAddress="PhysicianAddress"
$Rec11.CoPay="CoPay"
$Rec11.Notes="Notie voor de dokter"
$Rec11.Name="My Doktersbehandeling"
$Rec11.Grouping="AAA Test notities"
$Rec11
$Rec11 | Select-Object -Property Url,UserName,Password,Extra,Name,Grouping,Fav | ConvertTo-Csv -NoTypeInformation | Clip
'''

To create a Instant Messenger secure note:

'''
$Rec12 = New-Object -TypeName LPInstantMessenger
$Rec12.Type="Type"
$Rec12.Server="Server"
$Rec12.Port="53"
$Rec12.Notes="Notes"
$Rec12.UserName="BZanten"
$Rec12.Password="MyP@ssWr0d"
$Rec12.Name="My Instant Messenger"
$Rec12.Grouping="AAA Test notities"
$Rec12
$Rec12 | Select-Object -Property Url,UserName,Password,Extra,Name,Grouping,Fav | ConvertTo-Csv -NoTypeInformation | Clip
'''

To create a Insurance secure note:

'''
$Rec13 = New-Object -TypeName LPInsurance
$Rec13.Company="Company"
$Rec13.PolicyType="Policy Type"
$Rec13.PolicyNumber="Policy Number"
$Rec13.Expiration="24 dec 2018"
$Rec13.AgentName="Agent Name"
$Rec13.AgentPhone="Agent Phone"
$Rec13.Website="http://web.site"
$Rec13.Notes="Insurance notitie"
$Rec13.Name="My Insurance"
$Rec13.Grouping="AAA Test notities"
$Rec13
$Rec13 | Select-Object -Property Url,UserName,Password,Extra,Name,Grouping,Fav | ConvertTo-Csv -NoTypeInformation | Clip
'''

To create a Membership secure note:

'''
$Rec14 = New-Object -TypeName LPMembership
$Rec14.Organization="Organisatie"
$Rec14.MembershipNumber="Lidnummer"
$Rec14.MemberName="Lidnaam"
$Rec14.StartDate='23 jan 2002'
$Rec14.ExpirationDate='24 jan 2002'
$Rec14.Website='http:/web.site/membership'
$Rec14.Telephone='Telefoon'
$Rec14.Notes='Notities'
$Rec14.Password="MyP@ssWr0d"
$Rec14.Name='My Lidmaatschap'
$Rec14.Grouping="AAA Test notities"
$Rec14
$Rec14 | Select-Object -Property Url,UserName,Password,Extra,Name,Grouping,Fav | ConvertTo-Csv -NoTypeInformation | Clip
'''

To create a SSH Key secure note:

'''
$Rec15 = New-Object -TypeName LPSSHKey
$Rec15.BitStrength=256
$Rec15.Format="AES"
$Rec15.Passphrase="Wachtwoordzin"
$Rec15.PrivateKey="PrivateKey"
$Rec15.PublicKey="PublicKey"
$Rec15.Hostname="HostName"
$Rec15.Date='23 jan 2016'
$Rec15.Notes='Notitie SSHKey'
$Rec15.Name='My SSH Key'
$Rec15.Grouping="AAA Test notities"
$Rec15
$Rec15 | Select-Object -Property Url,UserName,Password,Extra,Name,Grouping,Fav | ConvertTo-Csv -NoTypeInformation | Clip
'''

To create a Social Security secure note:

'''
$Rec16 = New-Object -TypeName LPSocialSecurity
$Rec16.Number="Nummer"
$Rec16.Notes="Notitie Verzekering"
$Rec16.MemberName="Naam"
$Rec16.Name="My Social Security"
$Rec16.Grouping="AAA Test notities"
$Rec16
$Rec16 | Select-Object -Property Url,UserName,Password,Extra,Name,Grouping,Fav | ConvertTo-Csv -NoTypeInformation | Clip
'''

To create a WIFI Password secure note:

'''
$Rec17 = New-Object -TypeName LPWiFiPassword
$Rec17.SSID="SSID"
$Rec17.ConnectionType="ConnectionType"
$Rec17.ConnectionMode="ConnectionMode"
$Rec17.Authentication="Authentication"
$Rec17.Encryption="Encryption"
$Rec17.Use8021X="Use 802.1x"
$Rec17.FIPSMode="FIPS mode"
$Rec17.KeyType="KeyType"
$Rec17.Protected="Protected"
$Rec17.KeyIndex="KeyIndex"
$Rec17.Notes="Notitie Wifi"
$Rec17.Password="MyP@ssWr0d"
$Rec17.Name="My WIFI wachtwoord"
$Rec17.Grouping="AAA Test notities"
$Rec17.UserName="BZanten"
$Rec17
$Rec17 | Select-Object -Property Url,UserName,Password,Extra,Name,Grouping,Fav | ConvertTo-Csv -NoTypeInformation | Clip
'''

To Export all these objects to CSV and put them in you clipboard:

'''
@($Rec1,$Rec2,$Rec3,$Rec4,$Rec5,$Rec6,$Rec7,$Rec8,$Rec9,$Rec10,$Rec11,$Rec12,$Rec13,$Rec14,$Rec15,$Rec16,$Rec17) `
   | Select-Object -Property Url,UserName,Password,Extra,Name,Grouping,Fav | ConvertTo-Csv -NoTypeInformation | Clip
'''
