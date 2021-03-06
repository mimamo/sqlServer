USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABDET_STIMDET]    Script Date: 12/21/2015 14:34:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABDET_STIMDET]  @parm1 varchar (10) , @parm2 varchar (10) , @parm3 varchar (24) , @parm4 varchar (4) , @parm5 varchar (2) , @parm6 varchar (16) ,
@parm7 varchar (6) , @parm8 float, @parm9 smalldatetime , @parm10 int , @parm11 varchar (32) , @parm12 varchar (16), @parm13 varchar(1), @parm14 varchar(30), @parm15 varchar(30), @parm16 float, @parm17 float,
@parm18 varchar (10), @parm19 varchar(7), @parm20 varchar(1), @parm21 varchar(10),
@parm22 varchar (10), @parm23 varchar(10), @parm24 varchar(30), @parm25 varchar(20) as
select * from PJLABDET
where    docnbr     =  @parm1
and    gl_acct    =  @parm2
and    gl_subacct =  @parm3
and    labor_class_cd =  @parm4
and    work_type      =  @parm5
and    ld_id03        =  @parm6
and    work_comp_cd   =  @parm7
and    ld_id06        =  @parm8
and    ld_id08        =  @parm9
and    ld_id10        =  @parm10
and    pjt_entity     =  @parm11
and    project        =  @parm12
and    ld_status      =  @parm13
and    user1          =  @parm14
and    user2          =  @parm15
and    user3          =  @parm16
and    user4          =  @parm17
and    earn_type_id   =  @parm18
and    shift          =  @parm19
and    rate_source    =  @parm20
and    union_cd       =  @parm21
and    cpnyid_home    =  @parm22
and    cpnyid_chrg    =  @parm23
and    ld_id12        =  @parm24
and    ld_id14        =  @parm25
order by docnbr, linenbr
GO
