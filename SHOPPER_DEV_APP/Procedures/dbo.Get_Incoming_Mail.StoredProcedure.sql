USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Get_Incoming_Mail]    Script Date: 12/21/2015 14:34:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Get_Incoming_Mail    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[Get_Incoming_Mail] as
Select * from ECEmail where MailType <> 'X' AND  MailType <> 'S'
order by EDate DESC
GO
