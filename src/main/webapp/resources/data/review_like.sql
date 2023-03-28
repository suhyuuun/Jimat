CREATE TABLE review_like (
    review_like_seq number constraint review_like_seq_pk primary key,
    review_like_user_id varchar2(50),
    review_like_review_seq number,
    review_like_store_id varchar2(50)
);

ALTER TABLE review_like
ADD FOREIGN KEY(review_like_user_id) REFERENCES kakao_login(k_id)on delete cascade;

ALTER TABLE review_like
ADD FOREIGN KEY(review_like_store_id) REFERENCES SEOULFOODSTORE(FOODSTORE_ID) on delete cascade;

ALTER TABLE review_like
ADD FOREIGN KEY(review_like_review_seq) REFERENCES review(review_seq) on delete cascade;

CREATE SEQUENCE review_like_sequence
 START WITH 1 
 INCREMENT BY 1
 NOCACHE
 NOCYCLE;

COMMIT;

SELECT * FROM review_like;