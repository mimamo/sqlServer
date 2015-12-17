USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjlabdis_ustat]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[pjlabdis_ustat] @parm1 varchar (1) , @parm2 varchar (10) , @parm3 smallint , @parm4 varchar (4) ,
	@parm5 varchar (10), @parm6 varchar (8),
	@parm7 varchar (20) , @parm8 float  as
update pjlabdis
set 	status_1 = @parm1,
	lupd_datetime = getdate(),
	lupd_user = @parm5,
	lupd_prog = @parm6,
	dl_id13 = @parm7,
	dl_id07 = @parm8
where docnbr =  @parm2 and
linenbr = @parm3 and
hrs_type =  @parm4
GO
