USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SIMaterial_all]    Script Date: 12/21/2015 15:43:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SIMaterial_all    Script Date: 12/17/97 10:48:35 AM ******/
Create Procedure [dbo].[SIMaterial_all] @Parm1 Varchar(10) as
Select * from SIMatlTypes where Status = 'A' and MaterialType like @Parm1
Order by MaterialType
GO
