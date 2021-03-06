USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectGetKeyPeople]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sptProjectGetKeyPeople]
(
	@ProjectKey int
)

as

SELECT p.ProjectKey  
			, p.ProjectName
			, p.ProjectNumber                                                                                                                                                                                                                                        
			, c.CompanyName as ClientName
			, RTRIM(LTRIM(ISNULL(pc.FirstName,'') + ' ' + ISNULL(pc.LastName, ''))) as PrimaryContactName
			, pc.Phone1 as PrimaryContactPhone
			, pc.Email as PrimaryContactEmail
			, RTRIM(LTRIM(ISNULL(am.FirstName,'') + ' ' + ISNULL(am.LastName, ''))) as AccountManagerName
			, kp1.UserName as KeyPerson1
			, kp2.UserName as KeyPerson2
			, kp3.UserName as KeyPerson3
			, kp4.UserName as KeyPerson4
			, kp5.UserName as KeyPerson5
			, kp6.UserName as KeyPerson6
			, (Select StringSingular from tStringCompany (nolock) Where StringID = 'KeyUser1' and CompanyKey = p.CompanyKey) as KeyLabel1
			, (Select StringSingular from tStringCompany (nolock) Where StringID = 'KeyUser2' and CompanyKey = p.CompanyKey) as KeyLabel2
			, (Select StringSingular from tStringCompany (nolock) Where StringID = 'KeyUser3' and CompanyKey = p.CompanyKey) as KeyLabel3
			, (Select StringSingular from tStringCompany (nolock) Where StringID = 'KeyUser4' and CompanyKey = p.CompanyKey) as KeyLabel4
			, (Select StringSingular from tStringCompany (nolock) Where StringID = 'KeyUser5' and CompanyKey = p.CompanyKey) as KeyLabel5
			, (Select StringSingular from tStringCompany (nolock) Where StringID = 'KeyUser6' and CompanyKey = p.CompanyKey) as KeyLabel6
			FROM tProject p (NOLOCK)
			LEFT OUTER JOIN tCompany c (NOLOCK) on p.ClientKey = c.CompanyKey
			LEFT OUTER JOIN tUser am (NOLOCK) on am.UserKey = p.AccountManager
			LEFT OUTER JOIN tUser pc (nolock) ON pc.UserKey = p.BillingContact
			LEFT OUTER JOIN vUserName kp1 (nolock) ON p.KeyPeople1 = kp1.UserKey
			LEFT OUTER JOIN vUserName kp2 (nolock) ON p.KeyPeople2 = kp2.UserKey
			LEFT OUTER JOIN vUserName kp3 (nolock) ON p.KeyPeople3 = kp3.UserKey
			LEFT OUTER JOIN vUserName kp4 (nolock) ON p.KeyPeople4 = kp4.UserKey
			LEFT OUTER JOIN vUserName kp5 (nolock) ON p.KeyPeople5 = kp5.UserKey
			LEFT OUTER JOIN vUserName kp6 (nolock) ON p.KeyPeople6 = kp6.UserKey
  			WHERE ProjectKey = @ProjectKey
GO
