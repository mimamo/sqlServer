USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LineItem_EDPOID]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850LineItem_EDPOID] @EDPOID varchar(10) AS

Select * from ED850LineItem
where EDIPOID = @EDPOID
GO
