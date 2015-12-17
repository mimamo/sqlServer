USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJJNTDET_SPK0]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJJNTDET_SPK0]  @parm1 varchar (15) , @parm2 varchar (16) , @parm3beg smallint , @parm3end smallint   as
select * from PJJNTDET
where    vendid     =        @parm1 and
project    =        @parm2 and
linenbr    between  @parm3beg and @parm3end
order by vendid, project, linenbr
GO
