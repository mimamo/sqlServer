USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LineItem_EDPOID]    Script Date: 12/21/2015 13:56:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850LineItem_EDPOID] @EDPOID varchar(10) AS

Select * from ED850LineItem
where EDIPOID = @EDPOID
GO
