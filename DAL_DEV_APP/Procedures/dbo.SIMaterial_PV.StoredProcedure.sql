USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SIMaterial_PV]    Script Date: 12/21/2015 13:35:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SIMaterial_PV    Script Date: 12/17/97 10:48:35 AM ******/
Create Procedure [dbo].[SIMaterial_PV] @Parm1 Varchar(10) as
Select * from SIMatlTypes where MaterialType like @Parm1
Order by MaterialType
GO
