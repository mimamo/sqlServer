USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10530]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10530]

AS


Update tPreference Set RequireCommentsOnTime = RequireTimeDetails
GO
