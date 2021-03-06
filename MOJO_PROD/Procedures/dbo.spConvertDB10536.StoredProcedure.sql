USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10536]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10536]
AS

Update tPreference set UnverifiedTimeOption = ISNULL(UnverifiedTimeOption, 0) --default it to 0




INSERT tSystemMessage(Active, SecurityRight, AdminOnly, InactiveDate, MessageText, PlainMessageText) Values (1, null, 1, '11/15/2010', NULL,

'
Dear Administrators,

We will be rolling several new functions out of labs on our 10.5.3.7 Release set for Nov 8 for hosted clients and Nov 15th for clients running the system on their own servers. 

The following areas will be released:
  - Receipt Entry
  - Payment Entry
  - Post Transactions to the Ledger
  - Journal Entries
  - Google Calendar Sync
  
If you have not worked with these functions we recommend that your turn the labs on and get familliar with them before their full release. If you have any questions, please contact your Account Manager at <a href="mailto:support@workamajig.com">support@workamajig.com</a>.

Team Workamajig

'

)
GO
