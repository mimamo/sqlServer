USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_MSPUnlink]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_MSPUnlink] @parm1 varchar (16)  as
update pjproj set
    MSPINTERFACE = ' ',
    mspproj_id = 0,
    status_18 = ' '
    where project = @parm1
update pjpent set
    MSPINTERFACE = ' ',
    msptask_uid = 0
    where project = @parm1
GO
