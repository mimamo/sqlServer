USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Header_MaxEDIInvId]    Script Date: 12/21/2015 14:17:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850Header_MaxEDIInvId] As
Select Max(EDIInvId) From ED810Header
GO
