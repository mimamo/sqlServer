USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[p08990DeleteLogs]    Script Date: 12/21/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create procedure [dbo].[p08990DeleteLogs] as

Delete from WrkIChk
GO
