USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_1025_SOPlan]    Script Date: 12/21/2015 15:55:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_1025_SOPlan]   @invtid varchar(30),@siteid varchar(10),@plandate smalldatetime, @plantype varchar(2), @planref varchar(5)  as      
select * from SOPlan where 
invtid = @invtid
and siteid = @siteid 
and plandate = @plandate
and plantype = @plantype
and planref = @planref
order by invtid
GO
