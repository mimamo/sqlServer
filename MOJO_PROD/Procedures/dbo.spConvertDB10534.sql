USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10534]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10534]

AS


Update tPreference set DefaultAPApprover = DefaultARApprover
GO
