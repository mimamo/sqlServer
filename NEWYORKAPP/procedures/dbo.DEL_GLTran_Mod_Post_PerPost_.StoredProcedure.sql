USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DEL_GLTran_Mod_Post_PerPost_]    Script Date: 12/21/2015 16:00:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DEL_GLTran_Mod_Post_PerPost_    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[DEL_GLTran_Mod_Post_PerPost_] @parm1 varchar ( 6), @parm2 varchar ( 6) as
       Delete gltran from GLTran
           where Module  <> 'GL'
             and Posted   = 'P'
             and PerPost <= @parm1
             and PerEnt  <  @parm2
GO
