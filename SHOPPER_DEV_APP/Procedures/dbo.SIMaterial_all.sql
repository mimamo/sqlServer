USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SIMaterial_all]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SIMaterial_all    Script Date: 12/17/97 10:48:35 AM ******/
Create Procedure [dbo].[SIMaterial_all] @Parm1 Varchar(10) as
Select * from SIMatlTypes where Status = 'A' and MaterialType like @Parm1
Order by MaterialType
GO
