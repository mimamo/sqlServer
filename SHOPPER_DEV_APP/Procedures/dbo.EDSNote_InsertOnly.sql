USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSNote_InsertOnly]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[EDSNote_InsertOnly] @Level varchar(20), @Table varchar(20), @RevisedDate smalldatetime, @Text As text As
Insert Into Snote (dtRevisedDate, sLevelName, sTableName, sNoteText) Values (@RevisedDate, @Level, @Table, @Text)
GO
