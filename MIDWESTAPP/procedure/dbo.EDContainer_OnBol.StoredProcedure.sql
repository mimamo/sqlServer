USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_OnBol]    Script Date: 12/21/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDContainer_OnBol] @BolNbr varchar(20) As
Select * From EDContainer Where BolNbr = @BolNbr
GO
