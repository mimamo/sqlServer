USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[SIMaterial_Active]    Script Date: 12/21/2015 16:01:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SIMaterial_Active    Script Date: 4/7/98 12:42:26 PM ******/
/****** Object:  Stored Procedure dbo.SIMaterial_Active    Script Date: 12/17/97 10:48:35 AM ******/
Create Procedure [dbo].[SIMaterial_Active] @Parm1 Varchar(10) as
Select * from SIMatlTypes where MaterialType like @Parm1
And Status = 'A'
Order by MaterialType
GO
