USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[Get_Outgoing_Mail]    Script Date: 12/21/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Get_Outgoing_Mail    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[Get_Outgoing_Mail] as
Select * from ECEmail where MailType = 'X' OR MailType = 'S'
order by EDate DESC
GO
