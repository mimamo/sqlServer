USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSNote_InsertOnly]    Script Date: 12/21/2015 16:07:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[EDSNote_InsertOnly] @Level varchar(20), @Table varchar(20), @RevisedDate smalldatetime, @Text As text As
Insert Into Snote (dtRevisedDate, sLevelName, sTableName, sNoteText) Values (@RevisedDate, @Level, @Table, @Text)
GO
