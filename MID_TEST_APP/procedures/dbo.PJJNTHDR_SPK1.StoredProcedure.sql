USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJJNTHDR_SPK1]    Script Date: 12/21/2015 15:49:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJJNTHDR_SPK1]  @parm1 varchar (15) , @parm2 varchar (16)   as
select * from PJJNTHDR
where    vendid     =  @parm1 and
project    =  @parm2
order by vendid, project
GO
