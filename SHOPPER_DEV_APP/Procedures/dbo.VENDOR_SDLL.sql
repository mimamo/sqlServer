USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[VENDOR_SDLL]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[VENDOR_SDLL]  @parm1 varchar (15)   as
select name from VENDOR
where    vendid    =    @parm1
order by vendid
GO
