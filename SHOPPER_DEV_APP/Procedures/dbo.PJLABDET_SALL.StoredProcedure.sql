USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABDET_SALL]    Script Date: 12/21/2015 14:34:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABDET_SALL]  @parm1 varchar (10) , @parm2beg smallint , @parm2end smallint   as
select * from PJLABDET
where    docnbr     =  @parm1 and
linenbr  between  @parm2beg and @parm2end
order by docnbr, linenbr
GO
