USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[VENDOR_SDLL]    Script Date: 12/21/2015 13:57:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[VENDOR_SDLL]  @parm1 varchar (15)   as
select name from VENDOR
where    vendid    =    @parm1
order by vendid
GO
