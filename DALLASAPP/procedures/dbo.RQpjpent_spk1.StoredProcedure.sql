USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[RQpjpent_spk1]    Script Date: 12/21/2015 13:45:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.RQpjpent_spk1    Script Date: 9/4/2003 6:21:41 PM ******/

/****** Object:  Stored Procedure dbo.RQpjpent_spk1    Script Date: 7/5/2002 2:44:42 PM ******/

/****** Object:  Stored Procedure dbo.RQpjpent_spk1    Script Date: 1/7/2002 12:23:12 PM ******/

/****** Object:  Stored Procedure dbo.RQpjpent_spk1    Script Date: 1/2/01 9:39:38 AM ******/

/****** Object:  Stored Procedure dbo.RQpjpent_spk1    Script Date: 11/17/00 11:54:32 AM ******/

/****** Object:  Stored Procedure dbo.RQpjpent_spk1    Script Date: 10/25/00 8:32:17 AM ******/

/****** Object:  Stored Procedure dbo.RQpjpent_spk1    Script Date: 10/10/00 4:15:40 PM ******/

/****** Object:  Stored Procedure dbo.RQpjpent_spk1    Script Date: 10/2/00 4:58:16 PM ******/

/****** Object:  Stored Procedure dbo.RQpjpent_spk1    Script Date: 9/1/00 9:39:22 AM ******/

/****** Object:  Stored Procedure dbo.RQpjpent_spk1    Script Date: 03/31/2000 12:21:22 PM ******/

/****** Object:  Stored Procedure dbo.RQpjpent_spk1    Script Date: 2/2/00 12:18:19 PM ******/

/****** Object:  Stored Procedure dbo.RQpjpent_spk1    Script Date: 12/17/97 4:52:28 PM ******/
Create Procedure [dbo].[RQpjpent_spk1] @Parm1 Varchar(16), @Parm2 Varchar(32) as
select * from PJPENT where project = @parm1
and pjt_entity like @parm2 and status_pa = 'A'
order by project, pjt_entity
GO
