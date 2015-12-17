USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_GetCountForBol]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainer_GetCountForBol] @BolNbr varchar(20) As
Select count(*) From EDContainer Where BolNbr = @BolNbr And TareFlag = 1
GO
