USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJJNTHDR_SPK0]    Script Date: 12/21/2015 16:01:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJJNTHDR_SPK0]  @parm1 varchar (15) , @parm2 varchar (16)   as
select * from PJJNTHDR
where    vendid     =     @parm1 and
project    LIKE  @parm2
order by vendid, project
GO
