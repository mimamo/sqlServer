USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Kword_KWord]    Script Date: 12/21/2015 14:34:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Kword_KWord    Script Date: 4/17/98 12:50:25 PM ******/
/****** Object:  Stored Procedure dbo.Kword_KWord    Script Date: 4/7/98 12:51:20 PM ******/
Create Proc  [dbo].[Kword_KWord] @parm1 varchar ( 11) as
       Select * from KWord
           where KWord  LIKE  @parm1
           order by Kword
GO
