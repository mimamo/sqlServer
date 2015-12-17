USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJJNTHDR_SALL]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJJNTHDR_SALL]  @parm1 varchar (15) , @parm2 varchar (16)   as
select * from PJJNTHDR
where    vendid     LIKE  @parm1 and
project    LIKE  @parm2
order by vendid, project
GO
