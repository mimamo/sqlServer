USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[RQPJProj_Spk1_Excpt]    Script Date: 12/21/2015 16:01:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.RQPJProj_Spk1_Excpt    Script Date: 7/16/2004 10:05:46 AM ******/

CREATE Procedure [dbo].[RQPJProj_Spk1_Excpt] @Parm1 Varchar(16), @Parm2 varchar(16) as
select * from PJPROJ where Project <> @parm1 and project like @parm2 and status_pa = 'A' and status_po = 'A' order by project
GO
