USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_1031_SOPlan]    Script Date: 12/21/2015 15:37:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_1031_SOPlan]  @siteid varchar(10), @invtid varchar(30),@plandate smalldatetime, @plantype varchar(2), @planref varchar(5)  as      
select * from SOPlan where 
siteid = @siteid 
and invtid = @invtid
and plandate = @plandate
and plantype = @plantype
and planref = @planref
order by siteid
GO
