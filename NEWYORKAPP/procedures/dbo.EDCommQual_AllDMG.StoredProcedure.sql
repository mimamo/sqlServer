USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDCommQual_AllDMG]    Script Date: 12/21/2015 16:00:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.EDCommQual_All    Script Date: 5/28/99 1:17:40 PM ******/
CREATE PROCEDURE [dbo].[EDCommQual_AllDMG]
 @Parm1 varchar( 2 )
AS
 Select *
 From EDCommQual
 Where CommID LIKE @parm1
 Order By CommID
GO
