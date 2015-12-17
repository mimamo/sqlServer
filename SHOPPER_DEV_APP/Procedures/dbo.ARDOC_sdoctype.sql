USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDOC_sdoctype]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[ARDOC_sdoctype] @parm1 varchar (2) , @parm2 varchar (10)   as
select *
from  ARDOC
where ARDOC.doctype =  @parm1
and ARDOC.refnbr like @parm2
	order by refnbr
GO
