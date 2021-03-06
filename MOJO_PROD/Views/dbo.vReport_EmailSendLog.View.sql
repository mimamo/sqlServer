USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_EmailSendLog]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[vReport_EmailSendLog]

as 


Select 
	e.CompanyKey
	,e.ActionDate as [Date Sent]
	,e.EmailFromAddress as [From Address]
	,e.EmailToAddress as [To Address]
	,e.Subject
	,e.Body
	,Case When es.EmailSendLogID is null then 'Error Sending' else 'Email Sent' end as [Status Message]
	,e.CallingApplicationID as [Sending Source]
From tEmailSendLog e (nolock)
	LEFT OUTER JOIN (Select EmailSendLogID From tEmailSendLog (nolock) Where Message = 'Email successfully sent') as es on e.EmailSendLogID = es.EmailSendLogID
	Where Message = 'Email ready to send'
GO
