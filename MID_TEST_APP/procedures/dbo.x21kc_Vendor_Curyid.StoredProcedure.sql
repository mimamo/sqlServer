USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_Vendor_Curyid]    Script Date: 12/21/2015 15:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21kc_Vendor_Curyid] @parm1 varchar (15), @parm2 varchar (15) as
select v.vendid from vendor v, vendor x where
v.vendid = @parm1 and x.vendid = @parm2 and 
v.curyid <> x.curyid
GO
