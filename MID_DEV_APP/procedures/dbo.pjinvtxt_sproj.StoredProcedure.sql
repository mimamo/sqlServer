USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvtxt_sproj]    Script Date: 12/21/2015 14:17:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvtxt_sproj] @parm1 varchar (16) , @parm2 varchar (1)  as
select * from  pjinvtxt where
draft_num = ' ' and
text_type = @parm2 and
project = @parm1
GO
